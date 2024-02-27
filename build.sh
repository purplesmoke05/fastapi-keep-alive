echo "Network Creating...."
docker network create normal_py311_default1 >/dev/null 2>&1
docker network create normal_py311_default2 >/dev/null 2>&1
docker network create normal_py311_default3 >/dev/null 2>&1
docker network create normal_py311_default4 >/dev/null 2>&1
docker network create normal_py311_default5 >/dev/null 2>&1
docker network create normal_py311_default6 >/dev/null 2>&1
docker network create normal_py311_default7 >/dev/null 2>&1
docker network create normal_py311_default8 >/dev/null 2>&1
docker network create normal_py311_default9 >/dev/null 2>&1
docker network create normal_py311_default10 >/dev/null 2>&1

echo "Build...."
docker build -t uvicorn server/uvicorn
docker build -t gunicorn-uvicorn server/gunicorn-uvicorn
docker build -t hypercorn server/hypercorn

echo "Clean Existing Containers...."
docker rm fastapi-py311-normal-1  >/dev/null 2>&1
docker rm fastapi-py311-normal-2  >/dev/null 2>&1
docker rm fastapi-py311-normal-3  >/dev/null 2>&1
docker rm fastapi-py311-normal-4  >/dev/null 2>&1
docker rm fastapi-py311-normal-5  >/dev/null 2>&1
docker rm fastapi-py311-normal-6  >/dev/null 2>&1
docker rm fastapi-py311-normal-7  >/dev/null 2>&1
docker rm fastapi-py311-normal-8  >/dev/null 2>&1
docker rm fastapi-py311-normal-9  >/dev/null 2>&1
docker rm fastapi-py311-normal-10  >/dev/null 2>&1

docker rm case-1 > /dev/null 2>&1
docker rm case-2 > /dev/null 2>&1
docker rm case-3 > /dev/null 2>&1
docker rm case-4 > /dev/null 2>&1
docker rm case-5 > /dev/null 2>&1
docker rm case-6 > /dev/null 2>&1
docker rm case-7 > /dev/null 2>&1
docker rm case-8 > /dev/null 2>&1
docker rm case-9 > /dev/null 2>&1
docker rm case-10 > /dev/null 2>&1

docker rm lb-1 > /dev/null 2>&1
docker rm lb-2 > /dev/null 2>&1
docker rm lb-3 > /dev/null 2>&1
docker rm lb-4 > /dev/null 2>&1
docker rm lb-5 > /dev/null 2>&1
docker rm lb-6 > /dev/null 2>&1
docker rm lb-7 > /dev/null 2>&1
docker rm lb-8 > /dev/null 2>&1
