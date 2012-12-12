MODULE = unsg_splunk
PUPPETCONF = /etc/puppet/manifests/modules
PUPPETBIN = /usr/bin/puppet
MKDIR  = mkdir -p 
RSYNC  = /usr/bin/rsync -av --no-whole-file --exclude=Makefile

all: install

test: 
	@echo "Checking puppet syntax..."
	@ $(PUPPETBIN) --noop manifests/init.pp


update:
	@echo "Checking out the most updated Module code..."
	@svn up --no-auth-cache 

install: test
	@echo "Committing your changes to the upstream server..."
	@svn commit  --no-auth-cache



