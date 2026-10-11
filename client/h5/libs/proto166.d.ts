/** 爵位
 */
declare interface ProtoFmtInfo {
    16600: {
        desc: "打开爵位界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            code: number;
            /** 当前爵位 */
            nowjuewei: number;
        };
    };
    16601: {
        desc: "提升爵位";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            code: number;
            /** 当前爵位 */
            nowjuewei: number;
        };
    };
    16602: {
        desc: "爵位变动广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家id */
            role_id: number;
            /** 当前爵位 */
            nowjuewei: number;
        };
    };
}
