import fetch, { Response } from 'node-fetch';
import http from 'node:http';
import https from 'node:https';

const httpAgent = new http.Agent({
	keepAlive: true
});
const httpsAgent = new https.Agent({
	keepAlive: true
});

const options = {
	agent: function(_parsedURL) {
		if (_parsedURL.protocol == 'http:') {
			return httpAgent;
		} else {
			return httpsAgent;
		}
	}
};

const main = async () => {
	console.log("Start")
    const TARGET_URL = process.env.TARGET_URL;
    const REQUEST_NUM = parseInt(String(process.env.REQUEST_NUM), 10);
    const CYCLE_NUM = parseInt(String(process.env.CYCLE_NUM), 10);
    const SYNC_MODE = process.env.SYNC_MODE? true: false;

    const ENABLE_KEEP_ALIVE = process.env.ENABLE_KEEP_ALIVE? true: false;

    if (!TARGET_URL) {
        console.log("TARGET_URL must be set")
        return
    }
    console.log(`REQUEST_NUM: ${REQUEST_NUM}`)
    console.log(`CYCLE_NUM: ${CYCLE_NUM}`)
    console.log(`ENABLE_KEEP_ALIVE: ${ENABLE_KEEP_ALIVE}`)

    if (SYNC_MODE) {
		console.log("Sync mode")
        for (let c = 0; c < CYCLE_NUM; c++) {
            for (let r = 0; r < REQUEST_NUM; r++) {
                try{
	                if (ENABLE_KEEP_ALIVE) {
		                const _ = await fetch(TARGET_URL, options)
	                } else {
		                const _ = await fetch(TARGET_URL)
	                }
                } catch (e) {
                    console.log(e)
                }
            }
        }
    } else {
        console.log("Not sync mode")
        for (let c = 0; c < CYCLE_NUM; c++) {
            let spawn: Promise<Response>[] = [];
            for (let r = 0; r < REQUEST_NUM; r++) {
                if (ENABLE_KEEP_ALIVE) {
                    spawn.push(fetch(TARGET_URL, options))
                } else {
                    spawn.push(fetch(TARGET_URL))
                }
            }
            try{
                await Promise.all(spawn)
            } catch (e) {
                console.log(e)
            }
        }
    }
}

await main();