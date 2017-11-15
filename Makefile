BASEDIR = $(shell pwd)
REBAR = rebar3
RELPATH = _build/default/rel/udon
PRODRELPATH = _build/prod/rel/udon
APPNAME = udon
SHELL = /bin/bash

release:
	$(REBAR) release
	mkdir -p $(RELPATH)/../udon_config
	mkdir -p $(RELPATH)/../udon_data
	cp _build/default/rel/udon/etc/* _build/default/rel/udon_config/

console:
	cd $(RELPATH) && ./bin/udon console

prod-release:
	$(REBAR) as prod release
	mkdir -p $(PRODRELPATH)/../udon_config
	[ -f $(PRODRELPATH)/../udon_config/udon.conf ] || cp $(PRODRELPATH)/etc/udon.conf  $(PRODRELPATH)/../udon_config/udon.conf
	[ -f $(PRODRELPATH)/../udon_config/advanced.config ] || cp $(PRODRELPATH)/etc/advanced.config  $(PRODRELPATH)/../udon_config/advanced.config

prod-console:
	cd $(PRODRELPATH) && ./bin/udon console

compile:
	$(REBAR) compile

clean:
	$(REBAR) clean

test:
	$(REBAR) ct

devrel1:
	$(REBAR) as dev1 release

devrel2:
	$(REBAR) as dev2 release

devrel3:
	$(REBAR) as dev3 release

devrel: devrel1 devrel2 devrel3

dev1-console:
	$(BASEDIR)/_build/dev1/rel/udon/bin/$(APPNAME) console

dev2-console:
	$(BASEDIR)/_build/dev2/rel/udon/bin/$(APPNAME) console

dev3-console:
	$(BASEDIR)/_build/dev3/rel/udon/bin/$(APPNAME) console

devrel-start:
	for d in $(BASEDIR)/_build/dev*; do $$d/rel/udon/bin/$(APPNAME) start; done

devrel-join:
	for d in $(BASEDIR)/_build/dev{2,3}; do $$d/rel/udon/bin/$(APPNAME)-admin cluster join udon1@127.0.0.1; done

devrel-cluster-plan:
	$(BASEDIR)/_build/dev1/rel/udon/bin/$(APPNAME)-admin cluster plan

devrel-cluster-commit:
	$(BASEDIR)/_build/dev1/rel/udon/bin/$(APPNAME)-admin cluster commit

devrel-status:
	$(BASEDIR)/_build/dev1/rel/udon/bin/$(APPNAME)-admin member-status

devrel-ping:
	for d in $(BASEDIR)/_build/dev*; do $$d/rel/udon/bin/$(APPNAME) ping; done

devrel-stop:
	for d in $(BASEDIR)/_build/dev*; do $$d/rel/udon/bin/$(APPNAME) stop; done

start:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) start

stop:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) stop

attach:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) attach

