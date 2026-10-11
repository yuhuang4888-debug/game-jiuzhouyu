/** 中午答题
 */
declare interface ProtoFmtInfo {
    17400: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    17401: {
        desc: "活动信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0:关闭 1:准备 2:答题 3:答题间隔 4:结束倒计时 5:活动开始前提示 */
            stage: number;
            /** 活动时间 */
            time: number;
        };
    };
    17402: {
        desc: "进入场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    17403: {
        desc: "答题状态(进到活动场景中)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 状态 */
            stage: number;
            /** 第几题 */
            cur_num: number;
            /** 剩余题目 */
            remain_num: number;
            /** 答对题目数量 */
            correct_num: number;
            /** 题目Id */
            quiz_id: number;
            /** 结束时间 */
            end_time: number;
        };
    };
    17404: {
        desc: "排行榜信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            rank_list: {
                /** 角色id */
                role_id: number;
                /** 排名 */
                rank: number;
                /**  角色名字 */
                name: string;
                /** 积分 */
                score: number;
            }[];
            /** 答题间隔时间 */
            end_time: number;
            /** 我的排名 */
            sel_rank: number;
            /** 我的积分 */
            sel_score: number;
            /** 我的经验 */
            sel_exp: number;
        };
    };
    17405: {
        desc: "选择答案";
        send: (
            number: 17405,
            fmt: "c",
            args: [
                /**选项 12 未选择:0*/
                option: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**选项 12 未选择:0*/
            option: number
        ];
        recv: {
            errcode: number;
        };
    };
    17406: {
        desc: "单题结算";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 第几题 */
            cur_num: number;
            /** 0: 错误 1: 正确 2: 未作答 */
            result: number;
        };
    };
    17407: {
        desc: "准备时间";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 准备时间 */
            ready_time: number;
        };
    };
    17408: {
        desc: "结算界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 活动总经验 */
            total_exp: number;
            /** 奖励列表 */
            reward_list: {
                /** 奖励类型 */
                type: number;
                /** 类型Id */
                type_id: number;
                /** 奖励数量 */
                num: number;
            }[];
        };
    };
    17409: {
        desc: "退出场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
}
