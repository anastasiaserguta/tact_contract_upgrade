import "@stdlib/deploy";
import "@stdlib/ownable";
import "./traits";

contract ContractTestUpgrade with Deployable, Ownable, DelayedUpgradable {
    _version: Int = 1;
    initiatedAt: Int = 0;
    upgradeInfo: Upgrade = Upgrade{code: null, data: null, timeout: 0};

    id: Int as uint32 = 0;
    counter: Int as uint32 = 0;

    owner: Address;

    init(owner: Address) {
        self.owner = owner;
    }

    receive() {
        self.counter += 1;
        self.id += 1;
        cashback(sender());
    }

    receive("plus") {
        self.counter += 1;
        self.id += 1;
    }

    receive("minus") {
        self.requireOwner();
        self.id += 1;
        let amount: Int = myBalance() - ton("0.05");
        send(SendParameters{to: self.owner, value: amount});
    }

    get fun counter(): Int {
        return self.counter;
    }

    get fun id(): Int {
        return self.id;
    }
}
