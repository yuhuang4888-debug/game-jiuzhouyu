/** 模块加成效果
 */
declare interface ProtoFmtInfo {
    18401: {
        desc: "模块加成效果列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            buff_list: {
                key: number;
                /**  数据 */
                values: string;
            }[];
        };
    };
}
