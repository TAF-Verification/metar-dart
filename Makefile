PUB=pub
PUB_RUN=$(PUB) run
CIDER=cider
CIDER_BUMP=$(CIDER) bump

BRANCH := $(shell git rev-parse --abbrev-ref HEAD)

check_no_main:
ifeq ($(BRANCH),main)
	echo "You are good to go!"
else
	$(error You are not in the main branch)
endif

patch: check_no_main
	$(CIDER_BUMP) patch

minor: check_no_main
	$(CIDER_BUMP) minor

major:
	$(CIDER_BUMP) major

tests:
	$(PUB_RUN) test