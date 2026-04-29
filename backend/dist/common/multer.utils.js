"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.multerImageFilter = multerImageFilter;
const common_1 = require("@nestjs/common");
function multerImageFilter(allowedMimes) {
    return (req, file, cb) => {
        if (!allowedMimes.includes(file.mimetype)) {
            cb(new common_1.BadRequestException(`Tipo de archivo no permitido. Permitidos: ${allowedMimes.join(', ')}`), false);
        }
        else {
            cb(null, true);
        }
    };
}
//# sourceMappingURL=multer.utils.js.map