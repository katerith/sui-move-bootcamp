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

        let d = sum - b;
        assert!(d == 50, 604);
    }

    #[test]
    fun test_overflow() {
        // let a: u16 = 200;
        // let b: u16 = 200;

        // let sum = a + b;
        // assert!(sum == 400, 604);


        let a = 500;
        let b = 500;

        let c = a + b;
        assert!(c == 1000u16, 604);
    }

    #[test]
    fun test_mutability() {
        let mut a = 100;
        a = a - 10;
        assert!(a == 90, 605) ;
    }

    #[test]
    fun test_boolean(){
        let a = 500;
        let b = 1000;
        let greater = b > a;
        assert!(greater == true, 606);
    }

    #[test]
    fun test_loop(){
        let fact = 5;
        let mut result: u256 = 1;
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
        fun test_vector(){
            let mut myVec: vector<u8> = vector[10, 20, 30];
            let myOtherVec: vector<u8> = vector::empty();

            assert!(!myVec.is_empty() == true, 777);
            assert!(myVec.length() == 3, 778);
            assert!(myOtherVec.is_empty() == true, 779);

            myVec.push_back(40);

            assert!(myVec[3] == 40, 888);
            assert!(myVec.length() == 4, 889);
        }

    use std::string::{String};
    #[test]
    fun test_string(){
        let myString: String           = b"Hello, World!".to_string();
        let myStringArr: vector<u8>    = b"Hello, World!";

        assert!(myString.length() == myStringArr.length());
        assert!(myString == myStringArr.to_string());
    }

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