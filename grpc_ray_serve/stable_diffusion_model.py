from io import BytesIO
import torch

from ray import serve
from ray.serve.config import gRPCOptions
import stable_diffusion_pb2_grpc, stable_diffusion_pb2
from io import BytesIO


@serve.deployment(
    ray_actor_options={"num_gpus": 1},
    num_replicas=1,
    #is_driver_deployment=True
    #autoscaling_config={"min_replicas": 1, "max_replicas": 2},
)
class StableDiffusionV2: #(stable_diffusion_pb2_grpc.StableDiffusionServiceServicer, gRPCIngress):
    def __init__(self):
        from diffusers import EulerDiscreteScheduler, StableDiffusionPipeline

        model_id = "stabilityai/stable-diffusion-2"

        scheduler = EulerDiscreteScheduler.from_pretrained(
            model_id, subfolder="scheduler"
        )
        self.pipe = StableDiffusionPipeline.from_pretrained(
            model_id, scheduler=scheduler, revision="fp16", torch_dtype=torch.float16
        )
        self.pipe = self.pipe.to("cuda")

    async def Generate(self, request: stable_diffusion_pb2.StableDiffusionRequest) -> stable_diffusion_pb2.StableDiffusionResponse:  #prompt: str, img_size: int = 512):
        prompt = request.prompt
        assert len(prompt), "prompt parameter cannot be empty"

        image = self.pipe(prompt, height=512, width=512).images[0]

        file_stream = BytesIO()
        image.save(file_stream, "PNG")

        return stable_diffusion_pb2.StableDiffusionResponse(contents=file_stream.getvalue())

deployment = StableDiffusionV2.bind()
#serve.run(deployment, host="0.0.0.0")

grpc_port = 8888
grpc_servicer_functions = [
    "stable_diffusion_pb2_grpc.add_StableDiffusionServiceServicer_to_server",
]
serve.start(
    grpc_options=gRPCOptions(
        port=grpc_port,
        grpc_servicer_functions=grpc_servicer_functions,
    ),
)

app1 = "app1"
serve.run(deployment, name=app1, route_prefix=f"/{app1}")

