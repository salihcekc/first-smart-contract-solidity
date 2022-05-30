//SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.0;

contract MyContract {

    address public immutable owner;     //constructor içerisinde tek seferlik değişebilir.
    uint public index;
    mapping (uint => Su) public data;

    struct Su {
    //Su değerleri
    uint ID;
    uint blockNumber;
    uint8 pH;
    int temperature;
    bytes32 previousHash;
    bytes32 suHash;
    uint timeStamp;
    }
    
    constructor() {
        owner = msg.sender;
    }

    function setData(uint8 _pH, int _temperature) public {
        require(_pH >= 1 && _pH <= 14);
        index++;
        data[index].ID = index;
        data[index].blockNumber = block.number;
        data[index].pH = _pH;
        data[index].temperature = _temperature;
        veriHashDegerleri(index);
        data[index].timeStamp = block.timestamp;
    }

    // function getData(uint8 n_pH) public view returns(uint ID, uint8 pH, int temperature, bytes32 suHash){
    //     require(index >= 0);
    //     for (uint i = 0; i <= index; i++){
    //         require(data[i].pH == n_pH);
    //         return (data[i].ID, data[i].pH, data[i].temperature, data[i].suHash);
    //     }
    // }

    function veriHashDegerleri (uint _index) private returns (bytes32, bytes32) {
        data[_index].suHash = keccak256(abi.encodePacked(block.number,
                                                         msg.data,
                                                         data[_index].ID,
                                                         data[_index].pH,
                                                         data[_index].temperature,
                                                         data[_index].previousHash));
        if (_index == 1) {
        data[_index].previousHash = 0;
        }
        else if (_index > 1) {
        data[_index].previousHash = data[_index - 1].suHash;
        }
        return (data[_index].suHash, data[_index].previousHash);
    }
}
