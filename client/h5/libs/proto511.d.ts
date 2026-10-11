/** 蒙面
 */
declare interface ProtoFmtInfo {
    51101: {
        desc: "蒙面信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            mask_id: number;
            /** 结束时间戳 */
            end_time: number;
        };
    };
    51102: {
        desc: "取消蒙面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            mask_id: number;
            /** 结束时间戳 */
            end_time: number;
        };
    };
}
