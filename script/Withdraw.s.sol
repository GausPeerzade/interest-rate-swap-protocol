pragma solidity ^0.8.4;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "@earth/strategies/common/interfaces/IStrategy.sol";
import "@earth/vaults/EarthAutoCompoundingVaultPublic.sol";
import "@openzeppelin/token/ERC20/IERC20.sol";

contract Withdraw is Script {
    address _vaultParent = 0x3C2f0f872e24416a6EC8242834c7A893739B1322;
    address _vaultAsset0 = 0x7CF1A7ff462e82634Fca2Fd07042eE982Ead2c61;
    address _vaultAsset1 = 0xD6d88c60E41C03eCD1598933C16d4556Ea180939;

    function run() public {
        // string memory seedPhrase = vm.readFile(".secret");
        // uint256 ownerPrivateKey = vm.deriveKey(seedPhrase, 0);
        // uint256 userPrivateKey = vm.deriveKey(seedPhrase, 1);
        // address owner = vm.addr(ownerPrivateKey);
        // address user = vm.addr(userPrivateKey);
        // console2.log("user", user);
        uint privateKeyOwn = vm.envUint("OWNER_KEY");
        uint userPrivateKey = vm.envUint("PRIVATE_KEY");
        address user = vm.addr(userPrivateKey);
        address owner = vm.addr(privateKeyOwn);
        console2.log("user", user);

        uint256 withdrawAmountParent = EarthAutoCompoundingVaultPublic(
            _vaultParent
        ).maxWithdraw(user);
        uint256 withdrawAmountAsset0 = EarthAutoCompoundingVaultPublic(
            _vaultAsset0
        ).maxWithdraw(user);
        uint256 withdrawAmountAsset1 = EarthAutoCompoundingVaultPublic(
            _vaultAsset1
        ).maxWithdraw(user);
        console2.log(withdrawAmountParent);
        console2.log(withdrawAmountAsset0);
        console2.log(withdrawAmountAsset1);

        vm.startBroadcast(userPrivateKey);

        EarthAutoCompoundingVaultPublic(_vaultParent).withdraw(
            withdrawAmountParent,
            user,
            user
        );
        EarthAutoCompoundingVaultPublic(_vaultAsset0).withdraw(
            withdrawAmountAsset0,
            user,
            user
        );
        EarthAutoCompoundingVaultPublic(_vaultAsset1).withdraw(
            withdrawAmountAsset1,
            user,
            user
        );
        vm.stopBroadcast();
    }
}
// forge script script/Withdraw.s.sol:Withdraw --rpc-url https://rpc.testnet.mantle.xyz --broadcast -vvv --legacy --slow
