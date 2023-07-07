from brownie import ShowOrganization, accounts, config
import time 

def main():
    account = accounts.add(config['wallets']['from_key'])
    contract_address = ShowOrganization.deploy({'from':account}, publish_source=True)
    time.sleep(1)