/** 祈愿
 */
declare interface ProtoFmtInfo {
    41500: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            errcode: number;
        };
    };
    41501: {
        desc: "祈愿界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 1:金币祈愿 2:经验祈愿 */
                type: number;
                /** 剩余次数 */
                remain_times: number;
                /** 剩余免费次数 */
                free_times: number;
                /** 倒计时结束时间 */
                endtime: number;
            }[];
        };
    };
    41502: {
        desc: "祈愿";
        send: (
            number: 41502,
            fmt: "c",
            args: [
                /**1:金币祈愿 2:经验祈愿*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1:金币祈愿 2:经验祈愿*/
            type: number
        ];
        recv: {
            /** 1:金币祈愿 2:经验祈愿 */
            type: number;
            /** 暴击倍率 1:表示没有暴击 >1表示出现暴击 */
            crit: number;
            /** 对应的奖励 金币祈愿对应金币 经验祈愿对应经验 */
            reward: number;
        };
    };
}
