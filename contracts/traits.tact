import "@stdlib/ownable";

message Upgrade {
    code: Cell? = null;
    data: Cell? = null;
    timeout: Int = 0;
}

message Confirm {}

trait DelayedUpgradable with Upgradable {
    owner: Address;
    // _version: Int;
    _version: Int as uint32;
    initiatedAt: Int;
    upgradeInfo: Upgrade;

    receive(msg: Confirm) {
        require(now() >= self.initiatedAt + self.upgradeInfo.timeout, "DelayedUpgradable: Cannot confirm upgrade before timeout");

        if (self.upgradeInfo.code != null) {
            setCode(self.upgradeInfo.code!!);
        }
        if (self.upgradeInfo.data != null) {
            setData(self.upgradeInfo.data!!);
            throw(0);
        }
    }

    override inline fun upgrade(_: Context, msg: Upgrade) {
        self.upgradeInfo = msg;
        self.initiatedAt = now();
    }
}


trait Upgradable with Ownable {
    owner: Address;
    _version: Int as uint32;

    receive(msg: Upgrade) {
        let ctx = context();
        self.validateUpgrade(ctx, msg);
        self.upgrade(ctx, msg);

        self._version += 1;
    }

    virtual inline fun validateUpgrade(_: Context, __: Upgrade) {
        self.requireOwner();
    }

    virtual inline fun upgrade(_: Context, msg: Upgrade) {
        if (msg.code != null) {
            setCode(msg.code!!);
        }
        if (msg.data != null) {
            setData(msg.data!!);
            throw(0);
        }
    }

    get fun isUpgradable(): Bool {
        return true;
    }

    get fun version(): Int {
        return self._version;
    }
}

asm fun setCode(code: Cell) { SETCODE }

asm fun setData(data: Cell) { c4 POP }