// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "../src/strategies/irs/EarthLpStaking.sol";
import "../src/strategies/irs/CommonStrat.sol";
import "../src/strategies/common/interfaces/IStrategy.sol";
import "../src/vaults/EarthAutoCompoundingVaultPublic.sol";

contract DeployEarthAsset0VaultWithCommonStrategy is Script {
    address parentStrategy = 0xde792D4165D022d3E40bf5E51879e1664F344B6D;
    address _lp0Token = 0xB38E748dbCe79849b8298A1D206C8374EFc16DA7; //FusionX Dai Mantle Testnet

    uint256 _stratUpdateDelay = 172800;
    uint256 _vaultTvlCap = 10000e18;

    function setUp() public {}

    function run() public {
        uint privateKey = vm.envUint("PRIVATE_KEY");
        address acc = vm.addr(privateKey);
        console.log("Account", acc);

        vm.startBroadcast(privateKey);
        EarthAutoCompoundingVaultPublic cloudVault = new EarthAutoCompoundingVaultPublic(
                _lp0Token,
                "Earth-DAI-Vault",
                "Earth-DAI-Vault",
                _stratUpdateDelay,
                _vaultTvlCap
            );
        CommonStrat cloudStrategy = new CommonStrat(
            address(cloudVault),
            address(parentStrategy),
            2,
            100
        );
        cloudVault.init(IStrategy(address(cloudStrategy)));
        console.log("DAI Vault");
        console2.logAddress(address(cloudVault));
        console.log("DAI Strategy");
        console2.logAddress(address(cloudStrategy));

        vm.stopBroadcast();
    }
}
/* 
  Account 0x69605b7A74D967a3DA33A20c1b94031BC6cAF27c
  DAI Vault
  0xcb9c7ab6dcBC6e782fCcA59A79cBC6c71E1Cd0f6
  DAI Strategy
  0x8920A0346Be17c18F1F63C3DD347D7e565B7cEc6 */

//forge script script/DPV0.s.sol:DeployEarthAsset0VaultWithCommonStrategy --rpc-url https://rpc.testnet.mantle.xyz --broadcast -vvv --legacy --slow
