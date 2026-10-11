import { EventDispatcher } from "../util/EventDispatcher";
// TypeScript file
export class DropVo extends EventDispatcher {
    static client_start_id = 0;
    type = 0;
    type_id = 0;
    instance_id = 0;
    pos_x;
    pos_y;
    move_speed;
    move_last_time;
    count = 1;
    drop_vo;
    public constructor() {
        super();
    }
    public SetData(type, type_id, pos_x, pos_y, move_speed?, move_last_time?, count = 1, drop_vo?) {
        this.type = type;
        this.type_id = type_id;
        this.pos_x = pos_x;
        this.pos_y = pos_y;
        this.move_speed = move_speed;
        this.move_last_time = move_last_time;
        this.count = count;
        ++DropVo.client_start_id;
        this.instance_id = DropVo.client_start_id;
        this.drop_vo = drop_vo;
    }
}

window["DropVo"] = DropVo