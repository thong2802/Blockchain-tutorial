// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.9;

// import "@openzeppelin/contracts/utils/Context.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
// import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
// import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";


// interface IHero {
//     function mint(address to,uint256 hero_type) external returns (uint256);
// }

// contract Hero is ERC721Enumerable, Ownable, AccessControlEnumerable, IHero {
//     using Counters for Counters.Counter;
//     Counters.Counter private _tokenIdTracker;
//     string private _url;
//     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");


//     // even
//     event mint(address to, uint256 hero_type, uint256 tokenid);
    
//     constructor() ERC721("Stickman", "Hero") {
//         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
//     }

//     function _baseURI()
//         internal
//         view
//         override
//         returns (string memory _newBaseURI)
//     {
//         return _url;
//     }




//     function supportsInterface(bytes4 interfaceId)
//         public
//         view
//         virtual
//         override(ERC721Enumerable, AccessControlEnumerable)
//         returns (bool)
//     {
//         return super.supportsInterface(interfaceId);
//     }
// }