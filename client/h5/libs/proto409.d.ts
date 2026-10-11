/** 成就
人物等级达到20级才会开启成就
 */
declare interface ProtoFmtInfo {
    40900: {
        desc: "未领取奖励的成就id";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 成就Id */
                id: number;
            }[];
        };
    };
    40901: {
        desc: "成就总览";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当前阶数 */
            cur_stage: number;
            /** 只发可领取或者已领取的 */
            reward_list: {
                /** 需要星数 */
                need_star: number;
                /** 1:已完成未领取 2:已领取 */
                status: number;
            }[];
            /** 当前阶数 */
            new_cur_stage: number;
        };
    };
    40902: {
        desc: "领取成就总览奖励";
        send: (
            number: 40902,
            fmt: "i",
            args: [
                /**奖励对应的总星数*/
                total_star: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**奖励对应的总星数*/
            total_star: number
        ];
        recv: {
            /** 当前阶数 */
            cur_stage: number;
            /** 成功返回码为1，否则返回0， */
            resoult: number;
            /** 领取成功返回码为1，否则返回错误码 */
            errcode: number;
            /** 当前阶数 */
            new_cur_stage: number;
        };
    };
    40903: {
        desc: "获取成就列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 成就大类标签 */
                category: number;
                /** 成就Id */
                id: number;
                /** 进度 */
                progress: number;
                /** 成就状态 0:未完成 1:已完成未领取 2:已领取 */
                status: number;
            }[];
        };
    };
    40904: {
        desc: "更新成就注:如果当前显示的1星成就,但是后续的2星成就进度有变化也会推送过来,客户端只需更新缓存已有的成就id即可";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 只推送更新了状态的成就 */
            list: {
                /** 成就Id */
                id: number;
                /** 成就状态 0:未完成 1:已完成未领取 2:已领取 */
                status: number;
                /** 进度 */
                progress: number;
            }[];
        };
    };
    40905: {
        desc: "领取成就奖励";
        send: (
            number: 40905,
            fmt: "i",
            args: [
                /**成就Id*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**成就Id*/
            id: number
        ];
        recv: {
            /** 成功返回码为1，否则返回0 */
            resoult: number;
            /** 领取成功返回码为1，否则返回错误码 */
            errcode: number;
        };
    };
    40906: {
        desc: "成就总成就点";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当前星数 */
            star: number;
        };
    };
    40907: {
        desc: "成就总览奖励更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            reward_list: {
                /** 需要星数 */
                need_star: number;
                /** 1:已完成未领取 2:已领取 */
                status: number;
            }[];
            /** 当前阶数 */
            cur_stage: number;
            new_cur_stage: number;
        };
    };
    40908: {
        desc: "成就分类总览";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 成就类型 */
                type: number;
                /** 总成就点 */
                total_star: number;
                /** 当前成就点 */
                now_star: number;
            }[];
        };
    };
    40909: {
        desc: "成就类型总览";
        send: (
            number: 40909,
            fmt: "h",
            args: [
                /**成就大类标签*/
                category: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**成就大类标签*/
            category: number
        ];
        recv: {
            /** 成就大类标签 */
            category: number;
            list: {
                /** 成就Id */
                id: number;
                /** 进度 */
                progress: number;
                /** 成就状态 0:未完成 1:已完成未领取 2:已领取 */
                status: number;
            }[];
        };
    };
}
