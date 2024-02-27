run_h:
	sh build.sh
	sh run.sh hypercorn

run_g:
	sh build.sh
	sh run.sh gunicorn-uvicorn

run_u:
	sh build.sh
	sh run.sh uvicorn
