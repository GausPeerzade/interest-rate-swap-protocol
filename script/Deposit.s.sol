pragma solidity ^0.8.4;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "@earth/strategies/common/interfaces/IStrategy.sol";
import "@earth/vaults/EarthAutoCompoundingVaultPublic.sol";
import "@openzeppelin/token/ERC20/IERC20.sol";

contract Deposit is Script {
    address _vaultParent = 0x3C2f0f872e24416a6EC8242834c7A893739B1322; //Parent Valut
    address _parentStrat = 0x3872F3Ef026C983d0Aa03584EBE8466937508E88; //Parent Strat
    address _vaultAsset0 = 0x7CF1A7ff462e82634Fca2Fd07042eE982Ead2c61; //WZETA Vault
    address _vaultAsset1 = 0xD6d88c60E41C03eCD1598933C16d4556Ea180939; //ACE Vault
    address _lp0Token = 0xB38E748dbCe79849b8298A1D206C8374EFc16DA7; //WZETA ZetaTest
    address _lp1Token = 0xc92747b1e4Bd5F89BBB66bAE657268a5F4c4850C; //ACE Token
    address _stake = 0xff2AAe557c626b6097abB582638cbD01c8d7F5AA; //WZETA-ACE Lp

    function run() public {
        // string memory seedPhrase = vm.readFile(".secret");
        // uint256 ownerPrivateKey = vm.deriveKey(seedPhrase, 0);
        // uint256 userPrivateKey = vm.deriveKey(seedPhrase, 1);
        // address owner = vm.addr(ownerPrivateKey);
        // address user = vm.addr(userPrivateKey);

        uint privateKeyOwn = vm.envUint("OWNER_KEY");
        uint userPrivateKey = vm.envUint("PRIVATE_KEY");
        address user = vm.addr(userPrivateKey);
        address owner = vm.addr(privateKeyOwn);
        console2.log("user", user);

        uint256 depositAmountParent = IERC20(_stake).balanceOf(user) / 100;
        uint256 depositAmountAsset0 = IERC20(_lp0Token).balanceOf(user) / 100;
        uint256 depositAmountAsset1 = IERC20(_lp1Token).balanceOf(user) / 100;

        vm.startBroadcast(userPrivateKey);
        IERC20(_lp0Token).approve(_vaultAsset0, depositAmountAsset0);
        IERC20(_lp1Token).approve(_vaultAsset1, depositAmountAsset1);
        IERC20(_stake).approve(_vaultParent, depositAmountParent);
        // IStrategy(_parentStrat).unpause();

        EarthAutoCompoundingVaultPublic(_vaultParent).deposit(
            depositAmountParent,
            user
        );
        EarthAutoCompoundingVaultPublic(_vaultAsset0).deposit(
            depositAmountAsset0,
            user
        );
        EarthAutoCompoundingVaultPublic(_vaultAsset1).deposit(
            depositAmountAsset1,
            user
        );
        vm.stopBroadcast();
    }
}
//forge script script/Deposit.s.sol:Deposit --rpc-url https://rpc.testnet.mantle.xyz --broadcast -vvv --legacy --slow

/* not running
  47496234954147994
  84599117977636372
  94480 */
