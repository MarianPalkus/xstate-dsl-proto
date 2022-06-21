import { ValidationAcceptor, ValidationChecks, ValidationRegistry } from 'langium';
import { XstateDslProtoAstType, StateConfig } from './generated/ast';
import type { XstateDslProtoServices } from './xstate-dsl-proto-module';

/**
 * Registry for validation checks.
 */
export class XstateDslProtoValidationRegistry extends ValidationRegistry {
    constructor(services: XstateDslProtoServices) {
        super(services);
        const validator = services.validation.XstateDslProtoValidator;
        const checks: ValidationChecks<XstateDslProtoAstType> = {
            StateConfig: validator.checkStateConfigStartsWithCapital
        };
        this.register(checks, validator);
    }
}

/**
 * Implementation of custom validations.
 */
export class XstateDslProtoValidator {

    checkStateConfigStartsWithCapital(stateConfig: StateConfig, accept: ValidationAcceptor): void {
        if (stateConfig.name) {
            const firstChar = stateConfig.name.substring(0, 1);
            if (firstChar.toUpperCase() !== firstChar) {
                accept('warning', 'StateConfig name should start with a capital.', { node: stateConfig, property: 'name' });
            }
        }
    }

}
