/** 幻兽入侵
 */
declare interface ProtoFmtInfo {
    60300: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    60301: {
        desc: "幻兽入侵活动信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 阶段 0活动未开启 1活动开启 2活动开启着但现在不是可进入状态 */
            stage: number;
            /** 阶段结束时间戳 */
            end_time: number;
            /** 本阶段是否完成 1是 0否 */
            finish: number;
        };
    };
    60302: {
        desc: "幻兽入侵战场进度";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1即将开始 2即将结束 3即将退出 */
            stage: number;
            /** 结束时间戳 */
            end_time: number;
        };
    };
    60303: {
        desc: "幻兽入侵鼓舞";
        send: (
            number: 60303,
            fmt: "i",
            args: [
                /**使用的道具*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**使用的道具*/
            goods_id: number
        ];
        recv: {
            /** 道具 */
            goods_id: number;
            /** 叠加层数 */
            count: number;
        };
    };
    60304: {
        desc: "幻兽入侵伤害排行榜";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** boss 总血量 */
            boss_hp: number;
            /** 我的排名 */
            my_rank: number;
            /** 我的伤害值 */
            my_hurt: number;
            role_list: {
                /**  名字 */
                name: string;
                /** 伤害值 */
                hurt_value: number;
            }[];
        };
    };
    60305: {
        desc: "幻兽入侵结算信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1成功 0失败 */
            res: number;
            /** 排名 */
            rank: number;
            reward_list: any;
        };
    };
    60306: {
        desc: "幻兽入侵统计信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** boss 总血量 */
            boss_hp: number;
            /** 我的排名 */
            my_rank: number;
            /** 我的伤害值 */
            my_hurt: number;
            /** 最后一击玩家id */
            killer_id: number;
            role_list: {
                /** 玩家id */
                role_id: number;
                /**  名字 */
                name: string;
                /** 职业 */
                career: number;
                /** 性别 */
                sex: number;
                /** 转生数 */
                turn: number;
                /**  玩家头像 */
                picture: string;
                /** 战力 */
                power: number;
                /** 伤害值 */
                hurt_value: number;
            }[];
        };
    };
    60307: {
        desc: "幻兽入侵进入战场";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    60308: {
        desc: "幻兽入侵退出战场";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    60309: {
        desc: "幻兽阶段性伤害信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 下次奖励伤害值 0 则没有下个阶段了 */
            next_hurt_step: number;
            /** 奖励内容 */
            reward_list: any;
        };
    };
    60310: {
        desc: "采集物出现警告";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
}
