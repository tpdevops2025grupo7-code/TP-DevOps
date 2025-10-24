from fastapi import FastAPI, Response
from fastapi.responses import RedirectResponse
from newrelic import agent
import time
import random
import os

agent.initialize(os.getenv('NEW_RELIC_CONFIG_FILE'))
app = FastAPI()

@app.get("/")
def root():
    return RedirectResponse(url="/docs")

@app.get("/health")
def health_check():
   return{"status": "ok"}

@app.get("/check-member/{name}")
def check_member(name: str):
    return {"registered": name.lower() in members}

@app.get("/io_task")
def io_task():
    time.sleep(2)
    return "IO bound task finish!"

@app.get("/cpu_task")
def cpu_task():
    for i in range(10000):
        n = i*i*i
    return f"CPU bound task finish! {n}"

@app.get("/random_sleep")
def random_sleep():
    time.sleep(random.randint(0,5))
    return "random sleep"

@app.get("/random_status")
def random_status(response: Response):
    status_code = random.choice([200] * 6 + [300, 400, 400, 500])
    response.status_code = status_code
    return f"Status code: {status_code}"

members = [
    "jazmin",
    "maria",
    "juana"
]
