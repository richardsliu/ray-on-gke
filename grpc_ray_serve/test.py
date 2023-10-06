import requests
import os
import grpc
import stable_diffusion_pb2_grpc, stable_diffusion_pb2


prompt = "a cut cat is dancing on the grass."

channel = grpc.insecure_channel("stable-diffusion.endpoints.ricliu-gke-dev.cloud.goog:8888")
stub = stable_diffusion_pb2_grpc.StableDiffusionServiceStub(channel)

request = stable_diffusion_pb2.StableDiffusionRequest(prompt=prompt)
response, call = stub.Generate.with_call(request)

print(request)

with open("output.png", "wb") as f:
  f.write(response.contents)

