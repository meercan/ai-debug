start: 
	@docker-compose up
stop:
	@docker-compose down
clean: 
	@docker-compose rm -fsv