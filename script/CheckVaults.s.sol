pragma solidity ^0.8.4;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "@earth/strategies/common/interfaces/IStrategy.sol";
import "@earth/vaults/EarthAutoCompoundingVaultPublic.sol";
import "@openzeppelin/token/ERC20/IERC20.sol";

contract CheckVaults is Script {
    address _vaultParent = 0x3C2f0f872e24416a6EC8242834c7A893739B1322;
    address _vaultAsset0 = 0x7CF1A7ff462e82634Fca2Fd07042eE982Ead2c61;
    address _vaultAsset1 = 0xD6d88c60E41C03eCD1598933C16d4556Ea180939;

    function run() public {
        IStrategy parentStrategy = EarthAutoCompoundingVaultPublic(_vaultParent)
            .strategy();
        IStrategy asset0Strategy = EarthAutoCompoundingVaultPublic(_vaultAsset0)
            .strategy();
        IStrategy asset1Strategy = EarthAutoCompoundingVaultPublic(_vaultAsset1)
            .strategy();

        uint256 balanceOfParent = parentStrategy.balanceOf();
        uint256 balanceOfAsset0 = asset0Strategy.balanceOf();
        uint256 balanceOfAsset1 = asset1Strategy.balanceOf();
        bool epochRunning = parentStrategy.epochRunning();
        if (epochRunning) {
            console.log("running");
        } else {
            console.log("not running");
        }
        console2.log(balanceOfParent);
        console2.log(balanceOfAsset0);
        console2.log(balanceOfAsset1);
    }
}
//forge script script/CheckVaults.s.sol:CheckVaults --rpc-url https://rpc.testnet.mantle.xyz --broadcast -vvv --legacy --slow
