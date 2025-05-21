module sui_primitives::sui_primitives {

    #[test]
    fun test_numbers() {
        let a = 50;
        let b = 50;
        assert!(a == b, 601);
        let sum = a + b;
        assert!(sum == 100, 602);

        let sub = a - b;
        assert!(sub == 0, 603);

        // let d = a - b;
        // assert!(sub == 0, 603);
    }

    #[test]
    fun test_overflow() {
        let a: u16 = 200;
        let b: u16 = 200;

        let sum = a + b;

        assert!(sum == 400, 604) ;
    }

    #[test]
    fun test_mutability() {

    }

    #[test]
    fun test_boolean(){

    }

    #[test]
    fun test_loop(){
        let fact = 5;
        let mut result : u256 = 1;
        let mut i =2;
        while (i <= fact){
            result = result * i;
            i = i+1;
        };
        std::debug::print(&result);
        // assert_eq(result, 120);
        assert!(result == 120, 777);
    }

    #[test]
    // use std::debug;
    fun test_vector(){
        let mut myVec: vector<u8> = vector[10, 20, 30];
        let mut myOtherVec: vector<u8> = vector::empty();

        // assert!(myVec.is_empty() == true);
        // assert!(myOtherVec.is_empty() == true);

        myVec.push_back(40);

        assert!(myVec[3] == 40, 888);
        assert!(myVec.length() == 3, 889);
    }

    use std::string::{String};

    // #[test]
    // fun test_string(){
    //     let myStringArr : vector<u8>    = b"Hello, World!";


    // }

    #[test]
    fun test_string2(){
        let myStringArr = b"Hello, World!";
        let mut i: u64 = 0;
        let mut indexOfW: u64 = 0;
        while (i < myStringArr.length()){
            indexOfW = if(myStringArr[i] == 87) { i } else {indexOfW};
            i = i + 1;
        };
        assert!(indexOfW == 7, 999);
    }

}
