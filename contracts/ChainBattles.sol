// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721 {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct Specification {
        string name;
        uint256 level;
        uint256 speed;
        uint256 strength;
        uint256 life;
    }

    mapping(uint256 => Specification) public tokenIdToSpecifications;

    constructor() ERC721("Chain Battles", "CBTLS") {}

    function mint(string memory _name) public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdToSpecifications[newItemId] = Specification(_name, 0, 0, 0, 0);
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        _requireMinted(tokenId);

        return getTokenURI(tokenId);
    }

    function generateCharacter(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        bytes memory svg = abi.encodePacked(
            '<svg width="1000px" height="1000px" viewBox="0 0 1000 1000" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">',
            "<defs>",
            '<linearGradient x1="6.53949244%" y1="51.8009956%" x2="91.2918377%" y2="48.5183976%" id="bg">',
            '<stop stop-color="#000000" stop-opacity="0.389737216" offset="0%"></stop>',
            '<stop stop-color="#000000" stop-opacity="0" offset="100%"></stop>',
            "</linearGradient>",
            "</defs>",
            '<g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">',
            '<rect stroke="#851AE6" stroke-width="50" fill="#5E11B2" x="25" y="25" width="950" height="950" rx="217"></rect>',
            '<text font-family="Arial-BoldMT, Arial" font-size="120" font-weight="bold" letter-spacing="-4.42708062" fill="#FFFFFF">',
            '<tspan x="130" y="206">',
            getName(tokenId),
            "</tspan>",
            "</text>",
            '<rect fill="url(#bg)" x="50" y="246" width="901" height="171"></rect>',
            '<text font-family="Arial-BoldMT, Arial" font-size="120" font-weight="bold" letter-spacing="-4.42708062" fill="#5FE2F2">',
            '<tspan x="130" y="373">Level = ',
            getLevel(tokenId),
            "</tspan>",
            "</text>",
            '<text font-family="Arial-BoldMT, Arial" font-size="120" font-weight="bold" letter-spacing="-4.42708062" fill="#F0D178">',
            '<tspan x="130" y="548">Speed = ',
            getSpeed(tokenId),
            "</tspan>",
            "</text>",
            '<rect fill="url(#bg)" x="50" y="604" width="901" height="171"></rect>',
            '<text font-family="Arial-BoldMT, Arial" font-size="120" font-weight="bold" letter-spacing="-4.42708062" fill="#FF5656">',
            '<tspan x="130" y="730">Strength = ',
            getStrength(tokenId),
            "</tspan>",
            "</text>",
            '<text font-family="Arial-BoldMT, Arial" font-size="120" font-weight="bold" letter-spacing="-4.42708062" fill="#6BFC98">',
            '<tspan x="130" y="897">Life = ',
            getLife(tokenId),
            "</tspan>",
            "</text>",
            "</g>",
            "</svg>"
        );

        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    function getName(uint256 tokenId) public view returns (string memory) {
        string memory name = tokenIdToSpecifications[tokenId].name;
        return name;
    }

    function getLevel(uint256 tokenId) public view returns (string memory) {
        uint256 level = tokenIdToSpecifications[tokenId].level;
        return level.toString();
    }

    function getSpeed(uint256 tokenId) public view returns (string memory) {
        uint256 speed = tokenIdToSpecifications[tokenId].speed;
        return speed.toString();
    }

    function getStrength(uint256 tokenId) public view returns (string memory) {
        uint256 strength = tokenIdToSpecifications[tokenId].strength;
        return strength.toString();
    }

    function getLife(uint256 tokenId) public view returns (string memory) {
        uint256 life = tokenIdToSpecifications[tokenId].life;
        return life.toString();
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',
            tokenId.toString(),
            '",',
            '"description": "Battles on chain",',
            '"image": "',
            generateCharacter(tokenId),
            '"',
            "}"
        );

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function train(uint256 tokenId) external {
        require(msg.sender == ownerOf(tokenId), "not the owner");

        tokenIdToSpecifications[tokenId].level++;
        tokenIdToSpecifications[tokenId].speed += _random(6);
        tokenIdToSpecifications[tokenId].strength += _random(3);
        tokenIdToSpecifications[tokenId].life += _random(8);
    }

    function _random(uint256 number) private view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        block.difficulty,
                        msg.sender
                    )
                )
            ) % number;
    }
}
