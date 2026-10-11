/** 资源找回
 */
declare interface ProtoFmtInfo {
    41900: {
        desc: "界面信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            errcode: number;
            res_act: {
                /** 活动id */
                act_id: number;
                /** 活动子类 */
                act_sub: number;
                /** 剩余次数 */
                lefttimes: number;
                /** 剩余vip额外次数 */
                lefttimes_vip: number;
                /** 奖励等级 */
                reward_lv: number;
            }[];
        };
    };
    41903: {
        desc: "找回";
        send: (
            number: 41903,
            fmt: "ihchh",
            args: [
                act_id: number,
                /**活动子类*/
                act_sub: number,
                /**1 绑钻 2 金币*/
                type: number,
                /**找回次数*/
                times: number,
                /**额外找回次数*/
                times_others: number
            ]
        ) => never;
        sendFmt: "ihchh";
        sendArgs: [
            act_id: number,
            /**活动子类*/
            act_sub: number,
            /**1 绑钻 2 金币*/
            type: number,
            /**找回次数*/
            times: number,
            /**额外找回次数*/
            times_others: number
        ];
        recv: {
            errcode: number;
            /** 1 绑钻 2 金币 */
            type: number;
            /** 活动id */
            act_id: number;
            /** 子Id */
            act_sub: number;
            /** 剩余次数 */
            lefttimes: number;
            /** 剩余vip额外次数 */
            lefttimes_vip: number;
            /** 奖励等级 */
            reward_lv: number;
        };
    };
    41904: {
        desc: "一键找回";
        send: (
            number: 41904,
            fmt: "c",
            args: [
                /**1 绑钻 2 金币*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1 绑钻 2 金币*/
            type: number
        ];
        recv: {
            errcode: number;
            /** 1 绑钻 2 金币 */
            type: number;
            act_list: {
                /** 活动id */
                act_id: number;
                /** 子Id */
                act_sub: number;
                /** 剩余次数 */
                lefttimes: number;
                /** 剩余vip额外次数 */
                lefttimes_vip: number;
                /** 奖励等级 */
                reward_lv: number;
            }[];
        };
    };
}
