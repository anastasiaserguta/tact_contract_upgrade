import "@stdlib/deploy";
import "@stdlib/ownable";
import "./traits";

contract ContractTestUpgrade with Ownable, DelayedUpgradable {
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

    get fun counter(): Int {
        return self.counter;
    }

    get fun id(): Int {
        return self.id;
    }
}
