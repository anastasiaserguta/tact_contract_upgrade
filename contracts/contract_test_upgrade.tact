import "@stdlib/deploy";
import "@stdlib/ownable";
import "./traits";

contract ContractTestUpgrade with Deployable, Ownable, DelayedUpgradable {
    _version: Int as uint32 = 1;
    initiatedAt: Int = 0;
    upgradeInfo: Upgrade = Upgrade{code: null, data: null, timeout: 0};

    id: Int as uint32 = 0;
    counter: Int as uint32 = 0;
    newID: Int as uint32 = 0;
    randomNumber: Int;

    owner: Address;

    init(owner: Address) {
        self.owner = owner;
        self.randomNumber = 0;
    }

    receive() {
        self.counter += 1;
        self.id += 1;
        self.newID += 1;
        cashback(sender());
    }

    receive("plus") {
        self.counter += 1;
        self.id += 1;
        self.newID += 1;
    }

    receive("minus") {
        self.requireOwner();
        self.id += 1;
        self.newID += 1;
        let amount: Int = myBalance() - ton("0.05");
        send(SendParameters{to: self.owner, value: amount});
    }

    receive("random") {
        self.requireOwner();
        self.randomNumber = self.getRandomNumber();
    }

    fun getRandomNumber(): Int {
        let random: Int = random(1, 100);
        return random;
    }

    get fun counter(): Int {
        return self.counter;
    }

    get fun id(): Int {
        return self.id;
    }

    get fun newID(): Int {
        return self.newID;
    }

    get fun randomNumber(): Int {
        return self.randomNumber;
    }
}
