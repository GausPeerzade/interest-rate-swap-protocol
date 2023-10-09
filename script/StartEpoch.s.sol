pragma solidity ^0.8.4;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "@earth/strategies/common/interfaces/IStrategy.sol";
import "@earth/vaults/EarthAutoCompoundingVaultPublic.sol";
import "@openzeppelin/token/ERC20/IERC20.sol";

contract StartEpoch is Script {
    address _vaultParent = 0x3C2f0f872e24416a6EC8242834c7A893739B1322;
    address _vaultAsset0 = 0x7CF1A7ff462e82634Fca2Fd07042eE982Ead2c61;
    address _vaultAsset1 = 0xD6d88c60E41C03eCD1598933C16d4556Ea180939;

    function run() public {
        // string memory seedPhrase = vm.readFile(".secret");
        // uint256 ownerPrivateKey = vm.deriveKey(seedPhrase, 0);
        // address owner = vm.addr(ownerPrivateKey);
        // vm.startBroadcast(ownerPrivateKey);

        uint privateKeyOwn = vm.envUint("PRIVATE_KEY");
        uint userPrivateKey = vm.envUint("PRIVATE_KEY");
        address user = vm.addr(userPrivateKey);
        address owner = vm.addr(privateKeyOwn);
        console2.log("user", user);

        vm.startBroadcast(privateKeyOwn);
        ///start epoch
        IStrategy parentStrategy = EarthAutoCompoundingVaultPublic(_vaultParent)
            .strategy();
        IStrategy asset0Strategy = EarthAutoCompoundingVaultPublic(_vaultAsset0)
            .strategy();
        IStrategy asset1Strategy = EarthAutoCompoundingVaultPublic(_vaultAsset1)
            .strategy();
        address[] memory strategiesChild = new address[](2);
        strategiesChild[0] = address(asset0Strategy);
        strategiesChild[1] = address(asset1Strategy);
        parentStrategy.startEpoch(strategiesChild);
        vm.stopBroadcast();
    }
}
// forge script script/StartEpoch.s.sol:StartEpoch --rpc-url https://rpc.testnet.mantle.xyz --broadcast -vvv --legacy --slow
