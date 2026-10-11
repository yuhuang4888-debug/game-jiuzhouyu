/** 个人空间
 */
declare interface ProtoFmtInfo {
    14500: {
        desc: "个人空间错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            errcode: number;
        };
    };
    14501: {
        desc: "查看个人空间";
        send: (number: 14501, fmt: "l", args: [to_id: number]) => never;
        sendFmt: "l";
        sendArgs: [to_id: number];
        recv: {
            /** 玩家Id */
            id: number;
            name: string;
            career: number;
            guild_id: number;
            guild_name: string;
            lv: number;
            picture: string;
            picture_ver: number;
            /** 性别 1男 2女 */
            sex: number;
            sex_secrecy: number;
            birthday: number;
            /** 0 保密 1公开 */
            birthday_secrecy: number;
            signature: string;
            visit_list: {
                visit_id: number;
                visit_name: string;
                visit_time: number;
            }[];
            update_list: {
                update_id: number;
                update_name: string;
                update_time: number;
            }[];
            last_login_ip: string;
        };
    };
    14502: {
        desc: "修改个人空间信息";
        send: (
            number: 14502,
            fmt: "sccics",
            args: [
                picture: string,
                /**性别 1男 2女*/
                sex: number,
                /**0 保密 1公开*/
                sex_secrecy: number,
                birthday: number,
                birthday_secrecy: number,
                signature: string
            ]
        ) => never;
        sendFmt: "sccics";
        sendArgs: [
            picture: string,
            /**性别 1男 2女*/
            sex: number,
            /**0 保密 1公开*/
            sex_secrecy: number,
            birthday: number,
            birthday_secrecy: number,
            signature: string
        ];
        recv: {
            id: number;
            result: number;
        };
    };
}
