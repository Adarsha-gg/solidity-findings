-include .env

build:; forge build

deploy-sepolia:; forge script script/DeployFundme.s.sol:DeployFund --rpc-url $(SEPO_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv