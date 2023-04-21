all: prepare build run delay5s test

delay5s:
	# can be used to let components start working
	sleep 5

broker:
	docker-compose -f kafka/docker-compose.yaml up -d

sys-packages:
	sudo apt install -y docker-compose
	sudo apt install python3-pip -y
	sudo pip3 install pipenv

pipenv:
	pipenv install -r requirements-dev.txt	

prepare: clean sys-packages pipenv build run-broker

build:
	docker-compose build

run-broker:
	docker-compose up -d su-zookeeper su-broker

run:
	docker-compose up -d

run-screen: run-handler-screen run-verifier-screen run-updater-screen run-monitor-screen run-manager-screen run-downloader-screen

restart:
	docker-compose restart

run-monitor-screen:
	screen -dmS monitor bash -c "pipenv run python ./monitor/monitor.py config.ini"

run-monitor:
	pipenv run ./monitor/monitor.py config.ini

run-manager-screen:
	screen -dmS manager bash -c "pipenv run python ./manager/manager.py config.ini"

run-manager:
	pipenv run python ./manager/manager.py config.ini

run-verifier:
	pipenv run python verifier/verifier.py config.ini

run-verifier-screen:
	screen -dmS verifier bash -c "pipenv run python verifier/verifier.py config.ini"

run-updater:
	pipenv run python updater/updater.py config.ini

run-updater-screen:
	screen -dmS updater bash -c "pipenv run python updater/updater.py config.ini"

run-handler:
	pipenv run python handler/handler.py

run-handler-screen:
	screen -dmS handler bash -c "pipenv run python handler/handler.py config.ini"

run-system:
	pipenv run python protection_system/system.py

run-scada:
	pipenv run python scada/scada.py

run-file-server:
	export FLASK_DEBUG=1; pipenv run python ./file_server/server.py

test:
	pipenv run pytest -sv


clean:
	docker-compose down; pipenv --rm; rm -rf Pipfile*; echo cleanup complete

run-downloader:
	pipenv run python downloader/downloader.py config.ini

run-downloader-screen:
	screen -dmS downloader bash -c "pipenv run python downloader/downloader.py config.ini"
