"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const node_fetch_1 = __importDefault(require("node-fetch"));
const node_http_1 = __importDefault(require("node:http"));
const node_https_1 = __importDefault(require("node:https"));
const httpAgent = new node_http_1.default.Agent({
    keepAlive: true
});
const httpsAgent = new node_https_1.default.Agent({
    keepAlive: true
});
const options = {
    agent: function (_parsedURL) {
        if (_parsedURL.protocol == 'http:') {
            return httpAgent;
        }
        else {
            return httpsAgent;
        }
    }
};
const main = async () => {
    const TARGET_URL = process.env.TARGET_URL;
    const REQUEST_NUM = parseInt(String(process.env.REQUEST_NUM), 50);
    const CYCLE_NUM = parseInt(String(process.env.CYCLE_NUM), 10);
    const SYNC_MODE = process.env.SYNC_MODE ? true : false;
    const ENABLE_KEEP_ALIVE = process.env.ENABLE_KEEP_ALIVE ? true : false;
    if (!TARGET_URL) {
        console.log("TARGET_URL must be set");
        return;
    }
    if (SYNC_MODE) {
        for (let c = 0; c < CYCLE_NUM; c++) {
            for (let r = 0; r < REQUEST_NUM; r++) {
                try {
                    const _ = await (0, node_fetch_1.default)(TARGET_URL);
                }
                catch (e) {
                    console.log(e);
                }
            }
        }
    }
    else {
        let spawn = [];
        for (let c = 0; c < CYCLE_NUM; c++) {
            for (let r = 0; r < REQUEST_NUM; r++) {
                spawn.push((0, node_fetch_1.default)(TARGET_URL));
            }
        }
        try {
            await Promise.all(spawn);
        }
        catch (e) {
            console.log(e);
        }
    }
};
main();
