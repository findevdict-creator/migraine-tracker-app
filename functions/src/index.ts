import { initializeApp } from "firebase-admin/app";

initializeApp();

export { helloWorld } from "./helloWorld";
export { pushWakeup, registerPushToken } from "./push";
export { weatherCache } from "./weather";
export { accountCreated, accountDeleted, accountPurgeSweep } from "./account";
export { createShareLink, revokeShareLink, shareLinkSweep, shareLinkView } from "./share";
