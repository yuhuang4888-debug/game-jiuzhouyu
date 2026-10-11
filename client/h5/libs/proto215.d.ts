/** 聚魂本
 */
declare interface ProtoFmtInfo {
    21500: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    21501: {
        desc: "聚魂刷怪";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    21502: {
        desc: "召唤boss";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    21503: {
        desc: "击杀怪物数量";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 已经击杀 */
            kill: number;
        };
    };
    21504: {
        desc: "能量信息(弃用)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当前能量 */
            power: number;
        };
    };
    21505: {
        desc: "使用技能";
        send: (
            number: 21505,
            fmt: "l",
            args: [
                /**技能id*/
                skill_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**技能id*/
            skill_id: number
        ];
        recv: null;
    };
    21506: {
        desc: "通关信息(弃用)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 挑战状态  0:成功  1:挑战失败 */
            state: number;
            /** 击杀数量 */
            kill_num: number;
            /** 奖励列表 */
            reward_list: any;
        };
    };
    21507: {
        desc: "扫荡";
        send: (
            number: 21507,
            fmt: "lclc",
            args: [
                /**副本id*/
                dun_id: number,
                /**扫荡次数*/
                times: number,
                /**boss个数*/
                boss_num: number,
                /**是否自动购买 1 自动购买 0 不自动购买*/
                auto: number
            ]
        ) => never;
        sendFmt: "lclc";
        sendArgs: [
            /**副本id*/
            dun_id: number,
            /**扫荡次数*/
            times: number,
            /**boss个数*/
            boss_num: number,
            /**是否自动购买 1 自动购买 0 不自动购买*/
            auto: number
        ];
        recv: {
            /** 奖励列表 */
            reward_list: any;
        };
    };
    21508: {
        desc: "下一波时间";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 波数 */
            wave_num: number;
            /** 刷新时间戳   0没有下一波 */
            time: number;
        };
    };
    21509: {
        desc: "阶段奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            reward_list: {
                /** 副本id */
                dun_id: number;
                /** 0 未领取  1 可以领取 2 已经领取 */
                status: number;
            }[];
        };
    };
    21510: {
        desc: "领取奖励";
        send: (
            number: 21510,
            fmt: "i",
            args: [
                /**副本id*/
                dun_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**副本id*/
            dun_id: number
        ];
        recv: {
            /** 操作码 */
            code: number;
            dun_id: number;
        };
    };
}
