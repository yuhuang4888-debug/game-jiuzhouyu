/** 讨伐boss
 */
declare interface ProtoFmtInfo {
    20500: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    20501: {
        desc: "进入场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    20502: {
        desc: "退出场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
}
