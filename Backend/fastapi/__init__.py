import uvicorn
from Backend.config import Telegram
from Backend.fastapi.main import app

Port = Telegram.PORT
config = uvicorn.Config(
    app=app, 
    host='0.0.0.0', 
    port=Port,
    ssl_keyfile="/root/ren/singapore-madar24.taileb71f2.ts.net.key",
    ssl_certfile="/root/ren/singapore-madar24.taileb71f2.ts.net.crt"
)
server = uvicorn.Server(config)
