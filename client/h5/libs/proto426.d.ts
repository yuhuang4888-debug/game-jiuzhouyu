/** 角色改名
 */
declare interface ProtoFmtInfo {
    42601: {
        desc: "改角色名";
        send: (
            number: 42601,
            fmt: "si",
            args: [
                /**角色名*/
                name: string,
                /**消耗物品类型：1为免费，2为钻石，3为改名卡*/
                type: number
            ]
        ) => never;
        sendFmt: "si";
        sendArgs: [
            /**角色名*/
            name: string,
            /**消耗物品类型：1为免费，2为钻石，3为改名卡*/
            type: number
        ];
        recv: {
            /** 请求状态：1为修改成功，2为角色名已经被使用，3为包含非法字符，4为角色名称长度为2~6个汉字，5为包含敏感词，6修改失败 */
            result: number;
            /** 角色名 */
            name: string;
        };
    };
    42602: {
        desc: "是否免费";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1为是，2为否 */
            result: number;
        };
    };
    42603: {
        desc: "查看曾用名";
        send: (
            number: 42603,
            fmt: "il",
            args: [
                /**查看状态：1为查看自身；2为查看别的玩家*/
                type: number,
                /**别的玩家id，查看自身则为0*/
                id: number
            ]
        ) => never;
        sendFmt: "il";
        sendArgs: [
            /**查看状态：1为查看自身；2为查看别的玩家*/
            type: number,
            /**别的玩家id，查看自身则为0*/
            id: number
        ];
        recv: {
            name_list: {
                /**  名字 */
                name: string;
                /** 时间（时间戳形式） */
                time: number;
            }[];
        };
    };
    42604: {
        desc: "是否能改名字";
        send: (
            number: 42604,
            fmt: "si",
            args: [
                /**角色名*/
                name: string,
                /**消耗物品类型：1为免费，2为钻石，3为改名卡*/
                type: number
            ]
        ) => never;
        sendFmt: "si";
        sendArgs: [
            /**角色名*/
            name: string,
            /**消耗物品类型：1为免费，2为钻石，3为改名卡*/
            type: number
        ];
        recv: {
            /** 请求状态：1成功， */
            result: number;
            /** 角色名 */
            name: string;
        };
    };
}
