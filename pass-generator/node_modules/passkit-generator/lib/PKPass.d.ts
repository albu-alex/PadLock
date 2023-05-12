/// <reference types="node" />
import { Stream } from "stream";
import { Buffer } from "buffer";
import Bundle from "./Bundle";
import * as Schemas from "./schemas";
/** Exporting for tests specs */
export declare const propsSymbol: unique symbol;
export declare const localizationSymbol: unique symbol;
export declare const importMetadataSymbol: unique symbol;
export declare const createManifestSymbol: unique symbol;
export declare const closePassSymbol: unique symbol;
export declare const passTypeSymbol: unique symbol;
export declare const certificatesSymbol: unique symbol;
export default class PKPass extends Bundle {
    private [certificatesSymbol];
    private [propsSymbol];
    private [localizationSymbol];
    private [passTypeSymbol];
    /**
     * Either create a pass from another one
     * or a disk path.
     *
     * @param source
     * @returns
     */
    static from<S extends PKPass | Schemas.Template>(source: S, props?: Schemas.OverridablePassProps): Promise<PKPass>;
    /**
     * Creates a Bundle made of PKPass to be distributed
     * as a `.pkpasses` zip file. Returns a Bundle instance
     * so it can be outputted both as stream or as a buffer.
     *
     * Using this will freeze all the instances passed as
     * parameter.
     *
     * Throws if not all the files are instance of PKPass.
     *
     * @param passes
     */
    static pack(...passes: PKPass[]): Bundle;
    constructor(buffers?: Schemas.FileBuffers, certificates?: Schemas.CertificatesSchema, props?: Schemas.OverridablePassProps);
    /**
     * Allows changing the certificates, if needed.
     * They are actually expected to be received in
     * the constructor, but they can get overridden
     * here for whatever purpose.
     *
     * When using this setter, all certificates are
     * expected to be received, or an exception will
     * be thrown.
     *
     * @param certs
     */
    set certificates(certs: Schemas.CertificatesSchema);
    /**
     * Allows retrieving current languages
     */
    get languages(): string[];
    /**
     * Allows getting an image of the props
     * that are composing your pass instance.
     */
    get props(): Schemas.PassProps;
    /**
     * Allows setting a transitType property
     * for a boardingPass.
     *
     * It will (automatically) throw an exception
     * if current type is not "boardingPass".
     *
     * @param value
     */
    set transitType(value: Schemas.TransitType);
    /**
     * Allows getting the current transitType
     * from pass props.
     *
     * It will (automatically) throw an exception
     * if current type is not "boardingPass".
     */
    get transitType(): Schemas.TransitType;
    /**
     * Allows accessing to primaryFields object.
     *
     * It will (automatically) throw an exception
     * if no valid pass.json has been parsed yet
     * or, anyway, if it has not a valid type.
     */
    get primaryFields(): Schemas.Field[];
    /**
     * Allows accessing to secondaryFields object
     *
     * It will (automatically) throw an exception
     * if no valid pass.json has been parsed yet
     * or, anyway, if a valid type has not been
     * set yet.
     */
    get secondaryFields(): Schemas.Field[];
    /**
     * Allows accessing to auxiliaryFields object
     *
     * It will (automatically) throw an exception
     * if no valid pass.json has been parsed yet
     * or, anyway, if a valid type has not been
     * set yet.
     *
     * For Typescript users: this signature allows
     * in any case to add the 'row' field, but on
     * runtime they are only allowed on "eventTicket"
     * passes.
     */
    get auxiliaryFields(): Schemas.FieldWithRow[];
    /**
     * Allows accessing to headerFields object
     *
     * It will (automatically) throw an exception
     * if no valid pass.json has been parsed yet
     * or, anyway, if a valid type has not been
     * set yet.
     */
    get headerFields(): Schemas.Field[];
    /**
     * Allows accessing to backFields object
     *
     * It will (automatically) throw an exception
     * if no valid pass.json has been parsed yet
     * or, anyway, if a valid type has not been
     * set yet.
     */
    get backFields(): Schemas.Field[];
    /**
     * Allows setting a pass type.
     *
     * **Warning**: setting a type with this setter,
     * will reset all the imported or manually
     * setted fields (primaryFields, secondaryFields,
     * headerFields, auxiliaryFields, backFields)
     */
    set type(nextType: Schemas.PassTypesProps | undefined);
    get type(): Schemas.PassTypesProps | undefined;
    /**
     * Allows adding a new asset inside the pass / bundle;
     * If an empty buffer is passed, it won't be added to
     * the bundle.
     *
     * `manifest.json` and `signature` files will be ignored.
     *
     * If a `pass.json` is passed to this method (and it has
     * not been added previously), it will be read, validated
     * and merged in the current instance. Its properties
     * will overwrite the ones setted through methods.
     *
     * If a `pass.strings` file is passed, it will be read, parsed
     * and merged with the translations added previously.
     * Comments will be ignored.
     *
     * @param pathName
     * @param buffer
     */
    addBuffer(pathName: string, buffer: Buffer): void;
    /**
     * Given data from a pass.json, reads them to bring them
     * into the current pass instance.
     *
     * **Warning**: if this file contains a type (boardingPass,
     * coupon, and so on), it will replace the current one,
     * causing, therefore, the destroy of the fields added
     * previously.
     *
     * @param data
     */
    private [importMetadataSymbol];
    /**
     * Creates the manifest starting from files
     * added to the bundle
     */
    private [createManifestSymbol];
    /**
     * Applies the last validation checks against props,
     * applies the props to pass.json and creates l10n
     * files and folders and creates manifest and
     * signature files
     */
    private [closePassSymbol];
    /**
     * Exports the pass as a zip buffer. When this method
     * is invoked, the bundle will get frozen and, thus,
     * no files will be allowed to be added any further.
     *
     * @returns
     */
    getAsBuffer(): Buffer;
    /**
     * Exports the pass as a zip stream. When this method
     * is invoked, the bundle will get frozen and, thus,
     * no files will be allowed to be added any further.
     *
     * @returns
     */
    getAsStream(): Stream;
    /**
     * Exports the pass as a list of file paths and buffers.
     * When this method is invoked, the bundle will get
     * frozen and, thus, no files will be allowed to be
     * added any further.
     *
     * This allows developers to choose a different way
     * of serving, analyzing or zipping the file, outside the
     * default compression system.
     *
     * @returns a frozen object containing files paths as key
     * 		and Buffers as content.
     */
    getAsRaw(): {
        [filePath: string]: Buffer;
    };
    /**
     * Allows to add a localization details to the
     * final bundle with some translations.
     *
     * If the language already exists, translations will be
     * merged with the existing ones.
     *
     * Setting `translations` to `null`, fully deletes a language,
     * its translations and its files.
     *
     * @see https://developer.apple.com/documentation/walletpasses/creating_the_source_for_a_pass#3736718
     * @param lang
     * @param translations
     */
    localize(lang: string, translations: {
        [key: string]: string;
    } | null): void;
    /**
     * Allows to specify an expiration date for the pass.
     *
     * @param date
     * @returns
     */
    setExpirationDate(date: Date | null): void;
    /**
     * Allows setting some beacons the OS should
     * react to and show this pass.
     *
     * Pass `null` to remove them at all.
     *
     * @example
     * ```ts
     *		PKPassInstance.setBeacons(null)
     *		PKPassInstance.setBeacons({
     *			proximityUUID: "00000-000000-0000-00000000000",
     *		});
     * ```
     *
     * @see https://developer.apple.com/documentation/walletpasses/pass/beacons
     * @param beacons
     * @returns
     */
    setBeacons(beacons: null): void;
    setBeacons(...beacons: Schemas.Beacon[]): void;
    /**
     * Allows setting some locations the OS should
     * react to and show this pass.
     *
     * Pass `null` to remove them at all.
     *
     * @example
     * ```ts
     *		PKPassInstance.setLocations(null)
     *		PKPassInstance.setLocations({
     *			latitude: 0.5333245342
     *			longitude: 0.2135332252
     *		});
     * ```
     *
     * @see https://developer.apple.com/documentation/walletpasses/pass/locations
     * @param locations
     * @returns
     */
    setLocations(locations: null): void;
    setLocations(...locations: Schemas.Location[]): void;
    /**
     * Allows setting a relevant date in which the OS
     * should show this pass.
     *
     * @param date
     */
    setRelevantDate(date: Date): void;
    /**
     * Allows to specify some barcodes formats.
     * As per the current specifications, only the first
     * will be shown to the user, without any possibility
     * to change it.
     *
     * @see https://developer.apple.com/documentation/walletpasses/pass/barcodes
     * @param barcodes
     * @returns
     */
    setBarcodes(barcodes: null): void;
    setBarcodes(message: string): void;
    setBarcodes(...barcodes: Schemas.Barcode[]): void;
    /**
     * Allows to specify details to make this, an
     * NFC-capable pass.
     *
     * Pass `null` as parameter to remove it at all.
     *
     * @see https://developer.apple.com/documentation/walletpasses/pass/nfc
     * @param data
     * @returns
     */
    setNFC(nfc: Schemas.NFC | null): void;
}
