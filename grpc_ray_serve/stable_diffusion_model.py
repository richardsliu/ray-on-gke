from io import BytesIO
#from fastapi import FastAPI
#from fastapi.responses import Response
import torch

from ray import serve
from ray.serve.drivers import gRPCIngress
import stable_diffusion_pb2_grpc, stable_diffusion_pb2


#app = FastAPI()


#@serve.deployment(num_replicas=1, route_prefix="/")
#@serve.ingress(app)
#class APIIngress:
#    def __init__(self, diffusion_model_handle) -> None:
#        self.handle = diffusion_model_handle
#
#    @app.get(
#        "/imagine",
#        responses={200: {"content": {"image/png": {}}}},
#        response_class=Response,
#    )
#    async def generate(self, prompt: str, img_size: int = 512):
#        assert len(prompt), "prompt parameter cannot be empty"
#
#        image_ref = await self.handle.generate.remote(prompt, img_size=img_size)
#        image = await image_ref
#        file_stream = BytesIO()
#        image.save(file_stream, "PNG")
#        return Response(content=file_stream.getvalue(), media_type="image/png")


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
        return stable_diffusion_pb2.StableDiffusionResponse(contents=image)

deployment = StableDiffusionV2.bind()
#serve.run(deployment, host="0.0.0.0")
app1 = "app1"
serve.run(deployment, name=app1, route_prefix=f"/{app1}")

