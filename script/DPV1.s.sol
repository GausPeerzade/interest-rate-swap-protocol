// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "../src/strategies/irs/EarthLpStaking.sol";
import "../src/strategies/irs/CommonStrat.sol";
import "../src/strategies/common/interfaces/IStrategy.sol";
import "../src/vaults/EarthAutoCompoundingVaultPublic.sol";

contract DeployEarthAsset1VaultWithCommonStrategy is Script {
    address parentStrategy = 0xde792D4165D022d3E40bf5E51879e1664F344B6D;
    address _lp1Token = 0xc92747b1e4Bd5F89BBB66bAE657268a5F4c4850C; // FusionX Usdc token
    uint256 _stratUpdateDelay = 172800;
    uint256 _vaultTvlCap = 10000e18;

    function setUp() public {}

    function run() public {
        uint privateKey = vm.envUint("PRIVATE_KEY");
        address acc = vm.addr(privateKey);
        console.log("Account", acc);

        vm.startBroadcast(privateKey);
        EarthAutoCompoundingVaultPublic wethVault = new EarthAutoCompoundingVaultPublic(
                _lp1Token,
                "Earth-USDC-Vault",
                "Earth-USDC-Vault",
                _stratUpdateDelay,
                _vaultTvlCap
            );
        CommonStrat wethStrategy = new CommonStrat(
            address(wethVault),
            address(parentStrategy),
            1,
            100
        );
        wethVault.init(IStrategy(address(wethStrategy)));
        console.log("USDC Vault");
        console2.logAddress(address(wethVault));
        console.log("USDC Strategy");
        console2.logAddress(address(wethStrategy));
        vm.stopBroadcast();
    }
}
/* Account 0x69605b7A74D967a3DA33A20c1b94031BC6cAF27c
  USDC Vault
  0xd4e49984CF74049F9AA8EBBCB2413C251efa0675
  USDC Strategy
  0xDAa10Aa7C7cac87E9177e1fAEcB85E3312feA3B5*/

//forge script script/DPV1.s.sol:DeployEarthAsset1VaultWithCommonStrategy --rpc-url https://rpc.testnet.mantle.xyz --broadcast -vvv --legacy --slow
