DART=dart
DART_RUN=$(DART) run
PUB=pub
PUB_GLOBAL=$(PUB) global
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
	$(DART) .create_tag.dart
	git push --follow-tags

minor: check_no_main
	$(CIDER_BUMP) minor
	$(DART) .create_tag.dart
	git push --follow-tags

major:
	$(CIDER_BUMP) major
	$(DART) .create_tag.dart
	git push --follow-tags

coverage:
	$(DART) $(PUB_GLOBAL) activate coverage
	$(DART) $(PUB_GLOBAL) run coverage:test_with_coverage

tests:
	$(DART_RUN) test