import os
from contextlib import asynccontextmanager
import asyncpg
from fastapi import FastAPI, HTTPException

DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://postgres:postgres@localhost:5432/postgres"
)

db_pool = None


@asynccontextmanager
async def lifespan(app: FastAPI):
    global db_pool
    db_pool = await asyncpg.create_pool(DATABASE_URL)
    
    async with db_pool.acquire() as connection:
        # Создание таблицы при старте, если не существует
        await connection.execute("""
            CREATE TABLE IF NOT EXISTS visits (
                id INT PRIMARY KEY,
                count INT
            );
        """)
        # Вставка начальной строки
        await connection.execute("""
            INSERT INTO visits (id, count) 
            VALUES (1, 0) 
            ON CONFLICT (id) DO NOTHING;
        """)
    yield
    if db_pool:
        await db_pool.close()


app = FastAPI(lifespan=lifespan)


@app.get("/")
async def get_visitor():
    async with db_pool.acquire() as connection:
        count = await connection.fetchval("""
            UPDATE visits 
            SET count = count + 1 
            WHERE id = 1 
            RETURNING count;
        """)
        return {"message": f"Hello! You are visitor number {count}"}


@app.get("/health")
async def health_check():
    try:
        async with db_pool.acquire() as connection:
            await connection.fetchval("SELECT 1;")
        return {"status": "ok", "db": "connected"}
    except Exception:
        raise HTTPException(
            status_code=500, 
            detail={"status": "error", "db": "disconnected"}
        )