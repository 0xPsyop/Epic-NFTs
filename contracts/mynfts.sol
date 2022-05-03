// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage{

 using Counters for Counters.Counter;
 Counters.Counter private _tokenIds;

    constructor() ERC721 ("0xManujaya", "SILENT") {
       console.log("This is my NFT contract. Woah!");
    }
  
    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ["metaverse", "epic", "crazy", "gm", "awesome", "nice"];
    string[] secondWords = ["vitalik", "ethereum", "bitcoin", "satoshi", "tacos", "tokens"];
    string[] thirdWords = ["memes", "meebits", "doge", "pepe", "punks", "apes"];
    
    event newNftMinted(address sender, uint256 tokenId );

     // I create a function to randomly pick a word from each array.
  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    // I seed the random generator. More on this in the lesson. 
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    // Squash the # between 0 and the length of the array to avoid going out of bounds.
    rand = rand % firstWords.length;
    return firstWords[rand];
  }

  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }
   
   function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }


   function mintNft() public {
        require(_tokenIds.current() <= 69);
         uint256 newItemId = _tokenIds.current();

         string memory first = pickRandomFirstWord(newItemId);
         string memory second = pickRandomSecondWord(newItemId);
         string memory third = pickRandomThirdWord(newItemId);
         string memory combinedWord = string(abi.encodePacked(first, second, third));

         string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));
         
          // Get all the JSON metadata in place and base64 encode it.
      string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "the random generated dumb collection", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );


         console.log("\n--------------------");

         console.log(
              string(
                  abi.encodePacked(
                         "https://nftpreview.0xdev.codes/?code=",
                           finalTokenUri
                       )
                    )
                  );

         console.log("--------------------\n");


         _safeMint(msg.sender, newItemId);

         _setTokenURI(newItemId,finalTokenUri);
         
         console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

         _tokenIds.increment();

         emit newNftMinted(msg.sender, newItemId);
    }
}