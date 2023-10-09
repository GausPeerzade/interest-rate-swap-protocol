// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "../src/strategies/irs/EarthLpStaking.sol";
import "../src/strategies/irs/CommonStrat.sol";
import "../src/strategies/common/interfaces/IStrategy.sol";
import "../src/vaults/EarthAutoCompoundingVaultPublic.sol";

contract EarthLpStakingScript is Script {
    address _stake = 0xff2AAe557c626b6097abB582638cbD01c8d7F5AA; //Rivera Lp
    uint256 _poolId = 1;
    address _chef = 0x9316938Eaa09E71CBB1Bf713212A42beCBa2998F; //FusionX MasterChefV3
    address _router = 0x45e6f621c5ED8616cCFB9bBaeBAcF9638aBB0033; // FusionXv2 smart router
    address _reward = 0x8734110e5e1dcF439c7F549db740E546fea82d66; //Wbit address for now
    address _lp0Token = 0xB38E748dbCe79849b8298A1D206C8374EFc16DA7; //FusionX Dai
    address _lp1Token = 0xc92747b1e4Bd5F89BBB66bAE657268a5F4c4850C; //FusionX usdc token
    address _factory = 0x272465431A6b86E3B9E5b9bD33f5D103a3F59eDb; //FusionX v3 factory
    address riveraVault = 0xff2AAe557c626b6097abB582638cbD01c8d7F5AA; // rivera Dai-musd vault

    address[] _rewardToLp0Route = new address[](2);
    address[] _rewardToLp1Route = new address[](2);

    uint256 stratUpdateDelay = 172800;
    uint256 vaultTvlCap = 10000e18;

    function setUp() public {
        _rewardToLp0Route[0] = _reward;
        _rewardToLp0Route[1] = _lp0Token;
        _rewardToLp1Route[0] = _reward;
        _rewardToLp1Route[1] = _lp1Token;
    }

    function run() public {
        uint privateKey = vm.envUint("PRIVATE_KEY");
        address acc = vm.addr(privateKey);
        console.log("Account", acc);

        vm.startBroadcast(privateKey);
        //deploying the AutoCompounding vault
        EarthAutoCompoundingVaultPublic vault = new EarthAutoCompoundingVaultPublic(
                _stake,
                "Earth-DAI-USDC-Vault",
                "Earth-DAI-USDC-Vault",
                stratUpdateDelay,
                vaultTvlCap
            );
        CommonAddresses memory _commonAddresses = CommonAddresses(
            address(vault),
            _router
        );
        EarthLpStakingParams memory earthLpStakingParams = EarthLpStakingParams(
            _stake,
            _poolId,
            _chef,
            _rewardToLp0Route,
            _rewardToLp1Route,
            _lp0Token,
            _factory
        );

        //Deploying the parantStrategy

        EarthLpStaking parentStrategy = new EarthLpStaking(
            earthLpStakingParams,
            _commonAddresses,
            riveraVault
        );
        vault.init(IStrategy(address(parentStrategy)));
        console2.logAddress(address(vault.strategy()));
        console.log("ParentVault");
        console2.logAddress(address(vault));
        console.log("ParentStrategy");
        console2.logAddress(address(parentStrategy));
        vm.stopBroadcast();
    }
}

/*    Account 0x69605b7A74D967a3DA33A20c1b94031BC6cAF27c
  0xde792D4165D022d3E40bf5E51879e1664F344B6D
  ParentVault
  0xacFaf415595B2109B06D864B01fB282E0cE959A4
  ParentStrategy
  0xde792D4165D022d3E40bf5E51879e1664F344B6D
*/

// forge script script/EarthLpStaking.s.sol:EarthLpStakingScript --rpc-url https://rpc.testnet.mantle.xyz --broadcast -vvv --legacy --slow
