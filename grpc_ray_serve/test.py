import requests
import os
import grpc
import stable_diffusion_pb2_grpc, stable_diffusion_pb2

address = os.getenv('RAY_ADDRESS')
address = address[:-5]
print(address)


prompt = "a cut cat is dancing on the grass."

channel = grpc.insecure_channel("34.30.225.23:9000")
stub = stable_diffusion_pb2_grpc.StableDiffusionServiceStub(channel)

request = stable_diffusion_pb2.StableDiffusionRequest(prompt=prompt)
response, call = stub.Generate.with_call(request)

print(request)
print(response.contents)

#resp = requests.get(f"{address}:8000/imagine?prompt={input}")
#with open("output.png", 'wb') as f:
#    f.write(response.contents)
