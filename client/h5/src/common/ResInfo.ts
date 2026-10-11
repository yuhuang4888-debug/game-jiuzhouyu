export class ResInfo extends Laya.EventDispatcher {
    url: string;
    type: string|null;
    cache: boolean;
    group: string|null;
    ignoreCache: boolean;
    useWorkerLoader: boolean;
    originalUrl: string|null;

    createCache: boolean;
    createConstructParams: any[]|null;
    createPropertyParams: any;
}