
# Dashboard Dev
alias dashboard-server="cd /vagrant/server/src/dashboard/ && godep go run main.go server"
alias dashboard-watch="cd /vagrant/client/ && npm run watch-dev"
alias dashboard-reload="cd /vagrant/server/src/dashboard/static && go-bindata -pkg static -debug -prefix /vagrant/client/build /vagrant/client/build/..."
alias dashboard-build-prod="cd /vagrant/client/ && npm run build-pro"

# SSH Addresses
alias ionic-elastic-search="ssh -L 9200:localhost:9200 ubuntu@52.88.237.76"
alias ionic-dpxdt="cd ~/ && ssh jlibbey@dpxdt.in.ionisecurity.com"
alias ionic-dpxdt-export="cd ~/Repositories && scp -r dpxdt_regression_tests/logs jlibbey@dpxdt.in.ionisecurity.com:~/repositories/dpxdt_regression_tests"

