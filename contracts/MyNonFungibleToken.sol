pragma solidity ^0.4.18;

import "./ERC721.sol";

contract MyNonFungibleToken is ERC721 {
  /*** CONSTANTS ***/

  string public constant name = "MyNonFungibleToken";
  string public constant symbol = "MNFT";
  address contractOwner;
  address public generatedTo;
  uint256 prescribersCount=0;
  mapping (address => bool) generators;
  uint256 identityCount=0;

  bytes4 constant InterfaceID_ERC165 = bytes4(keccak256('supportsInterface(bytes4)'));

  bytes4 constant InterfaceID_ERC721 =
    bytes4(keccak256('name()')) ^
    bytes4(keccak256('symbol()')) ^
    bytes4(keccak256('totalSupply()')) ^
    bytes4(keccak256('balanceOf(address)')) ^
    bytes4(keccak256('ownerOf(uint256)')) ^
    bytes4(keccak256('approve(address,uint256)')) ^
    bytes4(keccak256('transfer(address,uint256)')) ;
    //bytes4(keccak256('transfe


  /*** DATA TYPES ***/

  struct Token {
    address currentOwner;
    address mintedBy;
    address mintedTo;
    uint64 mintedAt;
    string carNo;
    string carDetails;
  }


  /*** STORAGE ***/

  mapping (uint256 => Token) token;

  mapping (uint256 => address) tokenIndexToOwner;
  mapping (address => uint256) ownershipTokenCount;
  mapping (uint256 => address) tokenIndexToApproved;


  /*** EVENTS ***/

  event Mint(address owner, uint256 tokenId);


  /*** INTERNAL FUNCTIONS ***/

  function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
    return tokenIndexToOwner[_tokenId] == _claimant;
  }

  function _transfer(address _from, address _to, uint256 _tokenId) internal {
    ownershipTokenCount[_to]++;
    tokenIndexToOwner[_tokenId] = _to;

    if (_from != address(0)) {
      ownershipTokenCount[_from]--;
      delete tokenIndexToApproved[_tokenId];
    }
    token[_tokenId].currentOwner = _to;

    emit Transfer(_from, _to, _tokenId);
  }

  function _mint(address _generator,address _generatedTo,string _carNo, string _cardetails) internal returns (uint256 tokenId) {
    identityCount++;
    token[identityCount].mintedBy = _generator;
    token[identityCount].mintedTo = _generatedTo;
    token[identityCount].currentOwner = _generatedTo;
    token[identityCount].mintedAt = uint64(now);
    token[identityCount].carNo = _carNo;
    token[identityCount].carDetails = _cardetails;

    emit Mint(_generatedTo, tokenId);

    _transfer(0, _generatedTo, tokenId);
  }


  /*** ERC721 IMPLEMENTATION ***/

  function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
    return ((_interfaceID == InterfaceID_ERC165) || (_interfaceID == InterfaceID_ERC721));
  }

  function totalSupply() public view returns (uint256) {
    return identityCount;
  }

  function balanceOf(address _owner) public view returns (uint256) {
    return ownershipTokenCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address owner) {
    owner = tokenIndexToOwner[_tokenId];

    require(owner != address(0));
  }

  function transfer(address _to, uint256 _tokenId) external canTransfer(_tokenId) {
    require(_to != address(0));
    require(_to != address(this));
    //require(_owns(msg.sender, _tokenId));
    //Token memory token = tokens[_tokenId];
    token[_tokenId].currentOwner = _to;
    
    _transfer(msg.sender, _to, _tokenId);
  }
  
  modifier canTransfer(uint256 _tokenId){
    require (msg.sender == token[_tokenId].currentOwner);
    _;  
  }


  /*** OTHER EXTERNAL FUNCTIONS ***/

  constructor() public{
    contractOwner = msg.sender;
  }

  modifier canAdd{
    require(msg.sender == contractOwner);
    _;
  }

  function isGenerator(address _generator)  public returns(bool state){
    return state = generators[_generator];
  }   

  function addGenerators(address _generator) public canAdd {
    generators[_generator] = true ;
  }

  modifier onlyByGenerator() {
      require(generators[msg.sender]);
    _;
  }

  function mint(address _generatedTo,string _carNo, string _cardetails) onlyByGenerator external returns (uint256)  {
    return _mint(msg.sender,_generatedTo,_carNo,_cardetails);
  }

  function getToken(uint256 _tokenId) external view returns (uint256 Id, address mintedBy, address mintedTo, address currentOwner, uint64 mintedAt, string carNo, string carDetails) {
    Id=_tokenId;
    mintedBy = token[_tokenId].mintedBy;
    mintedTo = token[_tokenId].mintedTo;
    currentOwner = token[_tokenId].currentOwner;
    mintedAt = token[_tokenId].mintedAt;
    carNo = token[_tokenId].carNo;
    carDetails = token[_tokenId].carDetails;
  
  }
}